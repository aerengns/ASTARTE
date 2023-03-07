Steps to set up the Backend
- Clone the backend to project folder looking like this -> ASTARTE : app, backend (While cloning be careful since both the app and backend is named astarte in the repo)
- After creating a virtual environment write 'pip install -r requirements.txt'
- Install mmdetection from gitHub and put it in backendcore
- Open a checkpoints folder under mmdetection
- conda install pytorch torchvision OR pip install pytorch torchvision -> In case of an unkown pytorch error use torch instead
- pip install -U openmim
- mim install mmcv-full
- cd mmdetection
- pip install -v -e .
- Finally, create a .env file under backendapp and ask for a secret key from those who have it

---
### Running app with docker

If you want to run project without creating an environment, you can use

`docker login --username astarteapp`

`docker run astarteapp/backend_main:latest`

### Creating docker image after backend changes

To create the docker image after your changes to code use the command below in the directory where Dockerfile exists,

`docker build . -t astarteapp/backend_main:latest`
latest can be your version

In order to publish your image, you should have a docker hub account.

`docker push astarteapp/backend_main:latest`
latest can be your version



