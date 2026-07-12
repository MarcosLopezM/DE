FROM python:3.14-slim-trixie

COPY --from=ghcr.io/astral-sh/uv:0.11.27 /uv /uvx /bin/
COPY . /app


RUN uv venv .venv
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app
RUN uv sync --locked

CMD ["uv", "run", "main.py"]
