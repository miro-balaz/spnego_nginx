from flask import Flask,request

app= Flask("__name__")


@app.route("/hidden")
def rt_hidden():
    return "Hello to hidden {}".format(list(request.headers.items()))
@app.route("/")
def rt():
    return "Hello to flask {}".format(list(request.headers.items()))


if __name__=="__main__":
    app.run(port=5000,host='0.0.0.0')

