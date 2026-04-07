import sys
import json
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/")
def get_bins():
    council = request.args.get("council")
    uprn = request.args.get("uprn", "")
    postcode = request.args.get("postcode", "")

    if not council:
        return jsonify({"error": "council parameter is required"}), 400

    try:
        from uk_bin_collection.uk_bin_collection.collect_data import UKBinCollectionApp

        args = [council, "https://example.com"]
        if uprn:
            args += ["-u", uprn]
        if postcode:
            args += ["-p", postcode]

        result = UKBinCollectionApp().run(args)
        if isinstance(result, str):
            result = json.loads(result)

        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e), "type": type(e).__name__}), 500

@app.route("/health")
def health():
    return jsonify({"status": "ok"})
