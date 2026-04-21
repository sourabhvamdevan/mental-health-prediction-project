import pandas as pd
from prophet import Prophet

class ForecastEngine:
    def __init__(self):
        self.model = Prophet()
        self.trained = False
        self.target_column = None

    def _detect_columns(self, df):
        """
        Automatically detect date column and target column
        """

        
        date_cols = [col for col in df.columns if "date" in col.lower() or "time" in col.lower()]
        if not date_cols:
            raise Exception("No date column found in dataset")
        date_col = date_cols[0]

      
        numeric_cols = df.select_dtypes(include=['int64', 'float64']).columns.tolist()

        if not numeric_cols:
            raise Exception("No numeric column found for forecasting")

     
        priority_cols = [col for col in numeric_cols if any(x in col.lower() for x in ["stress", "score", "depression", "anxiety"])]
        
        target_col = priority_cols[0] if priority_cols else numeric_cols[0]

        return date_col, target_col

    def train(self, path):
        df = pd.read_csv(path)

   
        date_col, target_col = self._detect_columns(df)
        self.target_column = target_col

  
        df = df[[date_col, target_col]].copy()
        df = df.rename(columns={
            date_col: "ds",
            target_col: "y"
        })

        df["ds"] = pd.to_datetime(df["ds"], errors="coerce")
        df = df.dropna()


        self.model.fit(df)
        self.trained = True

    def forecast(self, days=7):
        if not self.trained:
            raise Exception("Model not trained")

        future = self.model.make_future_dataframe(periods=days)
        forecast = self.model.predict(future)

        result = forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail(days)

        return result
