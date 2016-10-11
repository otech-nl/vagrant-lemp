$INSTALL virtualenv python-pip python-dev libmysqlclient-dev
echo ". venv/bin/activate" >>/home/vagrant/.bashrc
sudo -u vagrant virtualenv venv
REQS=/home/vagarnt/public_html/requirements.txt
if [ ! -e $REQS ]
then
    sudo -u vagrant pip install $REQS
fi
