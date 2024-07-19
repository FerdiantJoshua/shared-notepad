import random

from flask import Flask, request, render_template


TEXT_MAX_LENGTH = 1048576 # around 1 MB


def create_app():
    app = Flask(__name__)

    @app.route('/', methods=['GET'])
    def index():
        existing_text = ""
        with open('text.txt', 'r', encoding='utf-8') as f_in:
            existing_text = f_in.read()
        return render_template('index.html', existing_text=existing_text)

    @app.route('/key', methods=['GET'])
    def key():
        key = _generate_key()
        return str(key)
    
    def _generate_key():
        random_key = random.randint(0,100)
        with open('key.txt', 'w', encoding='utf-8') as f_out:
            f_out.write(f'{random_key}')
        return random_key

    @app.route('/save', methods=['POST'])
    def save():
        text = request.form.get('text')
        req_key = request.form.get('key')

        if len(text) > TEXT_MAX_LENGTH:
            return f'Not Saved: text too long ({len(text)}/{TEXT_MAX_LENGTH})', 422
        
        with open('key.txt', 'r', encoding='utf-8') as f_in:
            key = f_in.readline(-1)

        new_key = ""
        if key.strip() != req_key.strip():
            return 'Not Saved', 401
        else:
            with open('text.txt', 'w', encoding='utf-8') as f_out:
                f_out.write(f'{text}')
            new_key = _generate_key()

        return f'[{new_key}] Saved'
    
    return app

application = create_app()

if __name__ == '__main__':
    application.run(host='0.0.0.0', port='5678')
