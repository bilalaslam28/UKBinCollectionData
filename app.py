import sys
import json
import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/debug")
def debug():
    # Show installed packages and try to find the right module
    try:
        import uk_bin_collection
        module_path = uk_bin_collection.__file__
        
        # List everything available in the package
        import pkgutil
        modules = [m.name for m in pkgutil.iter_modules(uk_bin_collection.__path__)]
        
        return jsonify({
            "module_path": module_path,
            "available_modules": modules,
            "python_version": sys.version
        })
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route("/")
def get_bins():
    council = request.args.get("council")
    uprn = request.args.get("uprn", "")
    postcode = request.args.get("postcode", "")

    if not council:
        return jsonify({"error": "council parameter is required"}), 400

    try:
        from uk_bin_collection.collect_data import UKBinCollectionApp

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
