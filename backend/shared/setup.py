from setuptools import find_packages, setup

setup(
    name="common",
    version="0.1",
    packages=find_packages(),
    # AUTOMATIC DEPENDENCY INSTALLATION
    install_requires=[
        "pydantic",
        "pydantic-settings",
        "azure-monitor-opentelemetry>=1.6.0",  # Shared logging dependency
        "opentelemetry-api",
        "opentelemetry-sdk",
    ],
)
