FROM continuumio/miniconda3

# Copy the conda environment definition to set up the environment
COPY huxt/environment.yml /huxt/
COPY huxt/model_build.sh /huxt/

WORKDIR /huxt

RUN ./model_build.sh

# Make RUN commands use the new conda environment
SHELL ["conda", "run", "-n", "huxt", "/bin/bash", "-c"]

# Now copy the rest of the code.  Done here so that environment changes don't cause a rebuild.
COPY huxt/ /huxt/

# Copy the SWEEP-modified config over the default one
COPY ./huxt/config.dat /huxt/code/config.dat

# Copy the SWEEP-specific script to run the HUXt code
# This command is last so that changes to the config in `run_huxt.sh`
# will not cause a huge rebuild of the docker container chain
COPY ./huxt/run_huxt.sh /run_huxt.sh
RUN chmod +x /run_huxt.sh

ARG SNAPTIME
ENV SNAPTIME $SNAPTIME

ARG OUTPUTPATH
ENV OUTPUTPATH $OUTPUTPATH

ARG INPUTPATH
ENV INPUTPATH $INPUTPATH

ENTRYPOINT /huxt/entrypoint.sh
