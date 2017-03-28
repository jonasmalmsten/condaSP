appdir=$(pwd)/work
notebookdir=$(pwd)/notebooks

if [ -z $appdir ]
then 
    echo Empty;
else 
     appdiroption="-v "$appdir:/app/hostmapdir;
     echo Mapping $appdiroption

fi

if [ -z $notebookdir ]
then 
    echo Empty;
else 
    notebookdiroption="-v "$notebookdir:/opt/notebooks;
    echo Mapping $notebookdiroption
fi

#echo docker run -i -t $appdiroption $notebookdiroption -p 3000:3000 -p 8888:8888 -p 8080:80 -p 8443:443 jonasmalmsten/jira2condasp
docker login
docker pull jonasmalmsten/condasp
docker run -i -t $appdiroption $notebookdiroption -p 8888:8888 jonasmalmsten/condasp