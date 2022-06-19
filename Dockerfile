FROM public.ecr.aws/lambda/python:3.6 as lambda-image
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

#------------------python 및 빌드 종속성 설치------------------#
RUN apt update && apt install -y libgl1-mesa-glx libglib2.0-0 && \
    apt install python3 -y --no-install-recommends && \
    apt install python3-pip -y --no-install-recommends && \
    apt install -y python3-dev
#------------------------------------------------------------#

#------------Lambda Runtime Interface Emulator 추가--------------#
# ENTRYPOINT에서 스크립트 사용을 통해 간단한 로컬 사용 지원
COPY ./entry_script.sh /entry_script.sh
ADD aws-lambda-rie /usr/local/bin/aws-lambda-rie

RUN chmod 755 /entry_script.sh
RUN chmod 755 /usr/local/bin/aws-lambda-rie

ENTRYPOINT [ "/entry_script.sh" ]
#------------------------------------------------------------#

#------------------작업 디렉토리 설정------------------#
RUN mkdir /var/task
WORKDIR /var/task
#--------------------------------------------------#

RUN pip install awslambdaric && \
    pip install boto3

#------------------labmda 런타임 이미지 복사------------------#
COPY lambda.py /var/task/
COPY --from=lambda-image /var/runtime /var/runtime
#---------------------------------------------------------#

CMD [ "lambda.handler" ]