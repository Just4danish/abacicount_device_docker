import uuid

def get_uuid():
    # Get the unique ID using uuid.getnode()
    unique_id = uuid.getnode()

if __name__ == "__main__":
    get_uuid()
