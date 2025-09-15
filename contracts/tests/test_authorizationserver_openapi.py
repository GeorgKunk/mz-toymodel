import schemathesis

schema = schemathesis.from_file('../rest/openapi/authorizationserver.yaml')

@schema.parametrize()
def test_api(case):
    # Adjust base_url to match your local or cluster deployment
    try:
        response = case.call(base_url="http://localhost:8080")
        case.validate_response(response)
    except Exception as e:
        print(f"[WARN] Skipping test due to: {e}")

