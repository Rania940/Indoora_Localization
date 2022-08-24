from random import Random
from flask import Flask , request
import random
from flask import jsonify

import numpy as np
import pickle
import joblib
#predicted location


# #load_model
# with open("model.pkl", "rb") as f:
#     model = pickle.load(f)

#load_model
with open("model2.sav", "rb") as f:
   model = joblib.load(f)


#prediction function
def predict_Location(RSSIs_arr):
    #predict
    RSSIs_arr [RSSIs_arr==0]=-90
    print(RSSIs_arr)
    pred = model.predict(RSSIs_arr)[0]
    #pred = model.predict(np.array([-51,-73,-86,-73,-71,-71]).reshape(1,-1))[0] 
    print(pred)
    return str(pred)

#predict_Location([0])
 
app = Flask(__name__)

@app.route('/test',methods=['GET'])
def helloHandler():
    return 'Hello from Flask Server'

#test flutter connection
@app.route('/locate',methods=['GET'])
def locate():
    x= str(random.randint(0, 9))
    return jsonify({'loc':x})


@app.route("/predict",methods=['POST','GET'])
def predict_location():
    if request.method == 'POST':
        RSSIs = request.data
        print(RSSIs)
        RSSIs_arr =  np.fromstring(RSSIs, dtype=float, sep=",")
        #print(RSSIs_arr)
        location = predict_Location(RSSIs_arr.reshape(1,-1))

        #location=3
    return str(location)

if __name__ == "__main__":
    ##app.run(host="192.168.1.4", port="8080")
    app.run(host='192.168.112.153', port="7452")