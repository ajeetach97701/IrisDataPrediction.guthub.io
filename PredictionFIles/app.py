from flask import Flask , request, jsonify
import pickle
import numpy as np

flask_app = Flask(__name__)
with open('iris_dataset.pickle', 'rb') as f:
    model = pickle.load(f)

@flask_app.route("/",methods = ["GET", "POST"])
def Home():
    if request.method == "POST":
        request_data = request.get_json()
        sepal_length = float(request_data['SepalLength'])
        sepal_width = float(request_data['SepalWidth'])
        petal_length = float(request_data['PetalLength'])
        petal_width = float(request_data['PetalWidth'])
        data = [[sepal_length, sepal_width, petal_length, petal_width]]
        print(data)
        prediction = model.predict(data).tolist()[0]
        
        # output = prediction.to_list()
        # print(prediction[0])
        response_data =  jsonify({
            'message':data,
            'prediction': prediction
                        })
        return response_data
        # return  sepal_length, sepal_width ,petal_length ,petal_width
    else:
        return "Invalid HTTP request method"



if __name__ == "__main__":
    flask_app.run(debug=True)
    