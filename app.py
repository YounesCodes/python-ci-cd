from flask import Flask
app = Flask(__name__)

@app.route("/")
def index():
    return {
        "message":"app is working.",
        "work done":"contenarized the app, pushed to github."
        # next step is to write ci/cd pipeline.
    }

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")


