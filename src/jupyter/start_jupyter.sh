#{ sleep 5 ; cp -r /app/tools /app/hostmapdir/ ; } &
/opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser
