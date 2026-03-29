# Student Salary Prediction

## Mission And Problem
The goal of this project is to help students understand how academic performance and internship experience relate to salary outcomes.  
Many students do not have accessible tools that connect their academic progress to employability.  
This project provides a salary prediction API and a mobile app for simple access to those insights.  
It combines a FastAPI backend with a Flutter mobile interface.

## Public API Endpoint
- Base URL: `https://linearregressionmodel-production-573f.up.railway.app`
- Swagger UI: `https://linearregressionmodel-production-573f.up.railway.app/docs`
- Prediction endpoint: `POST /predict`

Sample prediction request body:
```json
{
  "cgpa": 8.2,
  "internships": 2,
  "placed": "Yes"
}
```

## YouTube Demo
- [Watch here](https://youtu.be/RythTRWQdbc)

## How To Install API Packages And Run The API
1. Create and activate a virtual environment:
```powershell
python -m venv .venv
.\.venv\Scripts\activate
```

2. Install the API packages:
```powershell
python -m pip install -r requirements.txt
```

3. Start the API:
```powershell
cd summative\api
..\..\.venv\Scripts\python.exe -m uvicorn prediction:app --reload
```

4. Open Swagger UI locally:
```text
http://127.0.0.1:8000/docs
```

## Project Structure
```text
linear_regression_model/
|-- README.md
|-- requirements.txt
`-- summative/
    |-- api/
    |   `-- prediction.py
    |-- linear_regression/
    |   |-- best_salary_model.joblib
    |   |-- Placement.csv
    |   `-- multivariate.ipynb
    `-- FlutterApp/
        |-- lib/
        |   |-- models/
        |   |-- screens/
        |   |-- services/
        |   |-- theme/
        |   |-- widgets/
        |   |-- config.dart
        |   `-- main.dart
        `-- pubspec.yaml
```

## App Screenshot
Add your mobile app screenshot below before submission.

<img src="https://res.cloudinary.com/dy2opnabf/image/upload/v1774804443/Screenshot_20260329_185241_sn2t7o.png" width="50%"/>

## How To Run The Mobile App
1. Make sure the API is running locally or deployed publicly.

2. Open the Flutter project:
```powershell
cd summative\FlutterApp
```

3. Run the app against your public API:
```powershell
flutter run --dart-define=API_BASE_URL=https://linearregressionmodel-production-573f.up.railway.app
```

4. If you are testing locally on an Android emulator:
```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```
