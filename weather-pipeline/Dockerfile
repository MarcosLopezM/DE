FROM python:3.14-slim-trixie

COPY --from=ghcr.io/astral-sh/uv:0.11.27 /uv /uvx /bin/

WORKDIR /app

COPY requirements.txt .

RUN uv venv .venv
ENV PATH="/app/.venv/bin:$PATH"
RUN uv pip install -r requirements.txt

COPY . /app

CMD ["python", "main.py"]
