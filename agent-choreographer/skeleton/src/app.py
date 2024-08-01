"""${{values.artifact_id}}

${{values.description}}
"""
import pickle
import requests

import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def default_response():
    """Provide a simple textual response to the root url to verify the application is working.
    """
    return {"message": "Hello!  Tell me who you are via /hello?name=NameGoesHere"}

@app.get("/hello")
def hello(name: str = ""):
    """Provide a basic response that propagates a query string parameter.

    Keyword arguments:
    name -- name in which to respond to with greeting
    """
    return {"message": f"Hello {name}"}


@app.get("/ex1")
def fraud_prediction_example_1():
    """ Short lived - delete me asap
    """
    return fraud_prediction(100.0, 1.0, True, True, False)

@app.get("/ex2")
def fraud_prediction_example_2():
    """ Short lived - delete me asap
    """
    return fraud_prediction(100.0, 1.2, False, False, True)


# pylint: disable=too-many-locals

@app.get("/fraud")
def fraud_prediction(distance_from_last_tx: float, ratio_to_median_price: float,
                     using_pin: bool, using_chip: bool, online_purchase: bool):
    """ Short lived - delete me asap
    """

    # config
    threshhold = 0.95
    deployed_model_name = "fraud"
    rest_url = "https://fraud-fraud-detection.apps.ocpprod.home.glroland.com"
    infer_url = f"{rest_url}/v2/models/{deployed_model_name}/infer"

    # prep data matrix
    pin_float = 0.0
    if using_pin is True:
        pin_float = 1.0
    chip_float = 0.0
    if using_chip is True:
        chip_float = 1.0
    online_float = 0.0
    if online_purchase is True:
        online_float = 1.0
    data = [distance_from_last_tx, ratio_to_median_price, pin_float, chip_float, online_float]

    with open('scaler.pkl', 'rb') as handle:
        scaler = pickle.load(handle)

    input_dadta = scaler.transform([data]).tolist()[0]

    json_data = {
        "inputs": [
            {
                "name": "dense_input",
                "shape": [1, 5],
                "datatype": "FP32",
                "data": input_dadta
            }
        ]
    }
    response = requests.post(infer_url, json=json_data, verify=False, timeout=30)
    response_dict = response.json()
    prediction = response_dict['outputs'][0]['data']

    return prediction[0] > threshhold


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
