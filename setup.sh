#!/bin/sh

virtualenvdir="env/bin/"

# create virtualenv if not present
if [ ! -d $virtualenvdir ]
then
    echo "Creating virtual python environment in folder ./env"
    mkdir env
    virtualenv env
fi

# activate virtualenv
source env/bin/activate

# install dependencies
echo "Installing dependencies in the virtual environment"
pip install -r requirements.txt

echo "Done."
echo
echo "You should now:"
echo "1. Run source ./env/bin/activate to activate virtual environment"
echo "2. Create a Google API key and download client_credentials.json to the drive-up folder."
echo "   You can create them here:"
echo "   https://console.developers.google.com/start/api?id=drive\&credential=client_key"
echo "3. Run python drive-up.py -h to see help"