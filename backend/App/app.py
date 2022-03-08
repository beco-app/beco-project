from flask import Flask
app = Flask(__name__)

# Test
@app.route('/')
def hello_world():
  return 'Hello from Flask!'

if __name__ == '__main__':
  app.run()