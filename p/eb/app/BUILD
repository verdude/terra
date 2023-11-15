python_sources()

python_requirement(name="fastapi", requirements=["fastapi"])
python_requirement(name="uvicorn", requirements=["uvicorn"])
python_requirement(name="boto3", requirements=["boto3"])
python_requirement(name="botocore", requirements=["botocore"])

pex_binary(
    name="small",
    entry_point="uvicorn",
    execution_mode="venv",
    dependencies=[":app"]
)

file(
    name="dockerfile",
    source="Dockerfile",
)

relocated_files(
    name="files",
    files_targets=[
        ":dockerfile",
    ],
    src="app",
    dest="",
)

archive(
    name="dep",
    format="zip",
    files=[":files"],
    packages=[
        ":small",
    ],
)
