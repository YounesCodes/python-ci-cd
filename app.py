from flask import Flask
app = Flask(__name__)

@app.route("/")
def index():
    return {
        "05/04/2026": "containerized the app, pushed to github, added github actions workflow to build the image, extended the workflow to also push image to docker hub, added a test stage to complement the pipeline.",
        "06/04/2026": "extended the workflow to deploy app on EC2 instance."
    }

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")


