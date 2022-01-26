## mac下swagger转pdf
### 一、swagger转adoc
#### 1、安装
```bash
brew install swagger2markup-cli
```
#### 2、转换
```bash
mkdir output
curl -o swagger.json http://localhost:9099/swagger/doc.json
swagger2markup convert -i swagger.json -d ./output
tee ./output/index.adoc <<EOF
include::overview.adoc[]
include::paths.adoc[]
include::definitions.adoc[]
EOF
```
### 二、adoc转pdf或html
#### 1、安装
```bash
brew install asciidoctor
```
#### 2、转换
```bash
# html
asciidoctor ./output/index.adoc
# pdf
asciidoctor-pdf ./output/index.adoc
```
#### 3、pdf中文乱码解决
```bash
asciidoctor-pdf -a pdf-style=themes/basic-theme.yml -a pdf-fontsdir=fonts/ ./output/index.adoc -D ./output
```
### 三、脚本自动化执行
```bash
sh swagger2pdf-cli.sh  
Usage: swagger2pdf-cli.sh -url http://localhost/swagger.json [-type pdf|html, default=pdf]
```
