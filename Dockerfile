FROM continuumio/miniconda3

# Copy the conda environment definition to set up the environment
COPY ./environment.yml /huxt/

WORKDIR /huxt

RUN conda update -n base -c defaults conda
RUN conda env create --no-default-packages -f environment.yml

# Make RUN commands use the new conda environment
SHELL ["conda", "run", "-n", "huxt", "/bin/bash", "-c"]

# Now copy the rest of the code.  Done here so that environment changes don't cause a rebuild.
COPY ./ /huxt/

# Copy the SWEEP-modified config over the default one
COPY ./config.dat /huxt/code/config.dat

# Copy the SWEEP-specific script to run the HUXt code
# This command is last so that changes to the config in `run_huxt.sh`
# will not cause a huge rebuild of the docker container chain
COPY ./run_huxt.sh run_huxt.sh
RUN chmod +x run_huxt.sh

ARG SNAPTIME
ENV SNAPTIME $SNAPTIME

ARG OUTPUTPATH
ENV OUTPUTPATH $OUTPUTPATH

ARG INPUTPATH
ENV INPUTPATH $INPUTPATH

CMD ["sh", "-c", "./run_huxt.sh ${SNAPTIME} ${OUTPUTPATH} ${INPUTPATH}"]
