python_sources()

python_requirement(name="fastapi", requirements=["fastapi"])
python_requirement(name="uvicorn", requirements=["uvicorn"])

pex_binary(
    name="small",
    entry_point="uvicorn",
    execution_mode="venv",
)

file(
    name="dockerfile",
    source="Dockerfile",
)

archive(
    name="dep",
    format="zip",
    files=[":dockerfile"],
    packages=[
        ":small",
    ],
)
