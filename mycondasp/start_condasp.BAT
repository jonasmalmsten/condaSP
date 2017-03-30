set WD=%cd%

set appdir=%cd%\work
set notebookdir=%cd%\notebooks

set appdiroption=-v %appdir%:/app/hostmapdir
echo Mapping %appdiroption%
set notebookdiroption=-v %notebookdir%:/opt/notebooks
echo Mapping %notebookdiroption%

docker login
docker pull jonasmalmsten/condasp
docker run -i -t %appdiroption% %notebookdiroption% -p 8888:8888 jonasmalmsten/condasp