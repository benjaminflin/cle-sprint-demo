FROM closure
RUN sudo apt-get -y update
RUN sudo apt-get -y install cmake npm nodejs
RUN sudo su - closure -c "mkdir /home/closure/gaps"
RUN sudo su - closure -c "cd /home/closure/gaps && git clone https://github.com/benjaminflin/cle-sprint-demo.git && \
    git clone https://github.com/gaps-closure/program-dependence-graph.git && git clone https://github.com/gaps-closure/cvi.git"
RUN sudo su - closure -c "cd /home/closure/gaps/program-dependence-graph && \
    git checkout develop && \
    mkdir build && cd build && \
    cmake .. && make"
RUN sudo su - closure -c "cd /home/closure/gaps && wget https://github.com/MiniZinc/MiniZincIDE/releases/download/2.5.5/MiniZincIDE-2.5.5-bundle-linux-x86_64.tgz && \ 
    tar xf MiniZincIDE-2.5.5-bundle-linux-x86_64.tgz && \
    mv MiniZincIDE-2.5.5-bundle-linux-x86_64 minizinc"
RUN sudo su - closure -c "cd /home/closure/gaps/cvi/ && \
    git checkout develop && \
    cd cle-extension && \
    npm install && \ 
    python3 -m pip install -r conflict-analyzer/requirements.txt"

RUN sudo su - closure -c "mv /home/closure/gaps/cle-sprint-demo /home/closure/gaps/sprint-demo"
