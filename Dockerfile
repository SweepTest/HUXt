FROM continuumio/miniconda3

WORKDIR /huxt
# Copy the conda environment config over
COPY environment.yml .
# Create the environment
RUN conda env create -f environment.yml

# Make RUN commands use the new conda environment
SHELL ["conda", "run", "-n", "huxt", "/bin/bash", "-c"]

# Copy the code and data
COPY code code
COPY data data
RUN mkdir /huxt/figures

# Set the workdir to the code dir
WORKDIR /huxt/code

# Run the code (change later)
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "huxt", "python3", "HUXt_example.py"]
