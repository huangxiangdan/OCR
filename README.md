###简单OCR服务

环境部署：

mkdir ~/downloads
cp script.zip ~/downloads
mkdir -p ~/downloads/ocr
cd ~/downloads/ocr && tar xvzf ~/downloads/script/Dockerfiles/spiderman_base/dependency/ImageMagick.tar.gz && cd ImageMagick && ./configure && sudo make && sudo make install
cd ~/downloads/ocr && tar xvzf ~/downloads/script/Dockerfiles/spiderman_base/dependency/leptonica.tar.gz && cd leptonica && ./configure && sudo make && sudo make install
cd ~/downloads/ocr && tar xvzf ~/downloads/script/Dockerfiles/spiderman_base/dependency/tesseract-ocr.tar.gz && cd tesseract-ocr && ./configure && sudo make && sudo make install
sudo cp ~/downloads/ocr/tesseract-ocr/tessdata/eng.traineddata /usr/local/share/tessdata/

