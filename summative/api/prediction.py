# API/prediction.py

import os
from pathlib import Path
from typing import Literal

from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import AliasChoices, BaseModel, Field, HttpUrl
import joblib
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import SGDRegressor

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "best_salary_model.joblib"

model = None
model_load_error = None
if MODEL_PATH.exists():
    try:
        model = joblib.load(MODEL_PATH)
    except Exception as exc:
        model_load_error = str(exc)

app = FastAPI(
    title="Student Salary Prediction API",
    description="Predicts student salary from CGPA, internships, and placed status.",
    version="1.0.0",
)

origins = [
    origin.strip()
    for origin in os.getenv("ALLOW_ORIGINS", "*").split(",")
    if origin.strip()
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PredictionRequest(BaseModel):
    cgpa: float = Field(..., ge=0.0, le=10.0)
    internships: int = Field(..., ge=0, le=10)
    placed: Literal["Yes", "No"] = Field(
        ...,
        validation_alias=AliasChoices("placed", "placement_status"),
    )

class PredictionResponse(BaseModel):
    predicted_salary: float
    salary_unit: str
    model_path: str


class HealthResponse(BaseModel):
    status: str
    model_loaded: bool
    model_path: str
    model_load_error: str | None = None

@app.post("/predict", response_model=PredictionResponse)
def predict_salary(payload: PredictionRequest):
    if model is None:
        detail = (
            "Model is not available. Retrain the model or replace "
            "best_salary_model.joblib with one built using the current "
            "scikit-learn version."
        )
        if model_load_error:
            detail = f"{detail} Load error: {model_load_error}"

        raise HTTPException(status_code=503, detail=detail)

    data = pd.DataFrame([{
        "CGPA": payload.cgpa,
        "Internships": payload.internships,
        "Placed": payload.placed,
    }])
    pred = model.predict(data)[0]
    return PredictionResponse(
        predicted_salary=float(pred),
        salary_unit="INR LPA",
        model_path=str(MODEL_PATH),
    )

class RetrainRequest(BaseModel):
    data_url: HttpUrl

class RetrainResponse(BaseModel):
    message: str
    rows_used: int
    model_path: str


REQUIRED_COLUMNS = ["CGPA", "Internships", "Placed", "Salary (INR LPA)"]
COLUMN_ALIASES = {
    "PlacenentStatus": "Placed",
    "PlacementStatus": "Placed",
    "Salary": "Salary (INR LPA)",
}

PLACED_VALUE_ALIASES = {
    "placed": "Yes",
    "not placed": "No",
    "yes": "Yes",
    "no": "No",
}


def _normalize_dataframe_columns(new_df: pd.DataFrame) -> pd.DataFrame:
    renamed_columns = {
        source: target for source, target in COLUMN_ALIASES.items() if source in new_df.columns
    }
    if renamed_columns:
        new_df = new_df.rename(columns=renamed_columns)

    if "Placed" in new_df.columns:
        new_df["Placed"] = (
            new_df["Placed"]
            .astype(str)
            .str.strip()
            .str.lower()
            .map(PLACED_VALUE_ALIASES)
            .fillna(new_df["Placed"])
        )
    return new_df


def _train_model_from_dataframe(new_df: pd.DataFrame) -> RetrainResponse:
    global model, model_load_error

    new_df = _normalize_dataframe_columns(new_df)

    missing_columns = [column for column in REQUIRED_COLUMNS if column not in new_df.columns]
    if missing_columns:
        raise HTTPException(
            status_code=400,
            detail=f"Dataset is missing required columns: {', '.join(missing_columns)}",
        )

    new_df = new_df.dropna(subset=["Salary (INR LPA)"])
    if new_df.empty:
        raise HTTPException(
            status_code=400,
            detail="Dataset has no usable rows after removing records with missing Salary (INR LPA) values.",
        )

    X = new_df[["CGPA", "Internships", "Placed"]]
    y = new_df["Salary (INR LPA)"]

    numeric_features = ["CGPA", "Internships"]
    categorical_features = ["Placed"]

    numeric_transformer = StandardScaler()
    categorical_transformer = OneHotEncoder(drop="first", handle_unknown="ignore")

    preprocessor = ColumnTransformer(
        transformers=[
            ("num", numeric_transformer, numeric_features),
            ("cat", categorical_transformer, categorical_features),
        ]
    )

    lin_model = SGDRegressor(
        max_iter=1000,
        learning_rate="optimal",
        random_state=42
    )

    pipe = Pipeline(steps=[
        ("preprocess", preprocessor),
        ("model", lin_model)
    ])

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    pipe.fit(X_train, y_train)

    model = pipe
    model_load_error = None
    MODEL_PATH.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, MODEL_PATH)

    return RetrainResponse(
        message="Model retrained successfully with new data.",
        rows_used=len(new_df),
        model_path=str(MODEL_PATH),
    )


@app.get("/", response_model=HealthResponse)
def root():
    return HealthResponse(
        status="ok",
        model_loaded=model is not None,
        model_path=str(MODEL_PATH),
        model_load_error=model_load_error,
    )


@app.get("/health", response_model=HealthResponse)
def health_check():
    return HealthResponse(
        status="ok",
        model_loaded=model is not None,
        model_path=str(MODEL_PATH),
        model_load_error=model_load_error,
    )

@app.post("/retrain", response_model=RetrainResponse)
def retrain_model(req: RetrainRequest):
    new_df = pd.read_csv(req.data_url)
    return _train_model_from_dataframe(new_df)


@app.post("/retrain/upload", response_model=RetrainResponse)
async def retrain_model_from_upload(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(".csv"):
        raise HTTPException(status_code=400, detail="Only CSV uploads are supported.")

    content = await file.read()
    if not content:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    try:
        new_df = pd.read_csv(pd.io.common.BytesIO(content))
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Could not read uploaded CSV: {exc}") from exc

    return _train_model_from_dataframe(new_df)
