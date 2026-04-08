from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def index():
    return {
        "05/04/2026": "containerized the app, pushed to github, added github actions workflow to build the image, extended the workflow to also push image to docker hub, added a test stage to complement the pipeline.",
        "06/04/2026": "extended the workflow to deploy app on EC2 instance.",
        "08/04/2026": "added security scanning with Trivy in the pipeline + semgrep SAST + fixed findings flagged by both.",
        "09/04/2026": "modified ssh commands in pipeline to delete old images from instance and only keep latest to save storage."
    }

if __name__ == "__main__":
    host = os.environ.get("FLASK_HOST", "0.0.0.0") # to avoid hardcoded 0.0.0.0
    app.run(debug=False, host=host)


