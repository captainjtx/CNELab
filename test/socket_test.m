%Socket test

message='a=START_SAVE&FILE_PATH=c:\test\traj1\&FILE_NAME=-03700.map';
output_port=8000;
number_of_retries=50;

server(message, output_port, number_of_retries)