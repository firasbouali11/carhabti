import os
from time import sleep
import numpy as np
from flask import Flask,request,jsonify
import uuid
import pickle
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array, load_img

app = Flask(__name__)

def InitConfig():
    global models, brands, colors,regressor, brand_model_dict,classifier
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2' 
    models = pickle.loads(open("./models.pickle","rb").read())
    brands = pickle.loads(open("./brands.pickle","rb").read())
    colors = pickle.loads(open("./colors.pickle","rb").read())
    regressor = pickle.loads(open("./prediction_model.pickle", "rb").read())
    classifier = load_model("./classification_model.h5")
    print(" * Data and models are loaded successfully")

    df = pd.read_csv("cars.csv")
    dataPair = df[["car_brand", "car_model"]]
    df.car_model = df.car_model.apply(lambda x: x.split("\n")[0].strip())
    brand_model_dict = {}
    for brand, model in dataPair.values:
        if brand not in brand_model_dict:
            brand_model_dict[brand] = [model]
        if model not in brand_model_dict[brand]:
            brand_model_dict[brand].append(model)



@app.route("/classify",methods=["POST"])
def classification():
    try:
        file = request.files["image"]
        filename = str(uuid.uuid1())+"."+file.filename.split(".")[-1]
        file.save(filename)

        image = load_img(filename,target_size=(224,224))
        image = np.expand_dims(img_to_array(image),0)
        prediction = brands[np.argmax(classifier.predict(image))]

        os.remove(filename)
    except:
        return jsonify({
            "status":"error",
            "error":"une erreur s'est produite !"
        })
    return jsonify({
        "status":"success",
        "prediction": prediction
    })

@app.route("/predict",methods=["POST"])
def prediction():
    try:
        data = request.form.to_dict()
        x = [float(data["reservoir"])]
        model = [1.0 if e == data["model"] else 0.0 for e in models]
        color = [1.0 if e == data["color"] else 0.0 for e in colors]
        brand = [1.0 if e == data["brand"] else 0.0 for e in brands]
        x.extend(brand)
        x.extend(color)
        x.extend(model)

        prediction = regressor.predict([x])
    except:
        return jsonify({
            "status":"error",
            "error":"there is an error"
            })

    return jsonify({
        "status":"success",
        "prediction":prediction[0]
    })

@app.route("/data")
def getData():
    return jsonify({
        "brands": brand_model_dict,
        "colors": colors
    })

if __name__ == "__main__":
    InitConfig()
    app.run(debug=True,host="0.0.0.0")