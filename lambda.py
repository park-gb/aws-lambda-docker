def handler(event, context):
    
    print(f"event: {event}")
    content = event['body']
    print(f"event.body: {content}") # 파일 내용 출력
    
    response = {
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS, POST, GET'
        },
        "statusCode" : 200,
        "body" : f"Content: {content}",
    }
    
    return response