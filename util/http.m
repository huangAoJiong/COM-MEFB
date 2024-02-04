function [result]=http(msg,types,id)
if (~exist('id', 'var'))
   id = '1587555900';
    types = 'send_private_msg';
end
% if (~exist('types', 'var'))
%    types = 'send_private_msg';
% end
if (~exist('msg', 'var'))
   msg = '空参数——测试';
end

if (strcmp(types, '私聊') || strcmp(types, 'send_private_msg'))
    types = 'send_private_msg';
    query = ['user_id=',id,'&message=',msg];
elseif (strcmp(types, '群发') || strcmp(types, 'send_group_msg'))
    types = 'send_group_msg';
    query = ['group_id=',id,'&message=',msg];
else
    types = 'send_private_msg';
    query = ['user_id=',id,'&message=',msg];
end

   uri = ['http://192.168.192.31:25733/',types,'?',query];

    import matlab.net.* %导入Matlab网络请求库
    import matlab.net.http.*

    uri = URI(uri);%请求地址;
    uri.Query = matlab.net.QueryParameter(query);%get  附加请求参数 

    r = RequestMessage;
    r.Method = 'GET';%使用GET请求类型

    response = send(r,uri);%发送请求
    status = response.StatusCode;%获取服务器响应的状态码
    if (status==200) %一般成功响应的状态码为200 表示ok 即成功
        content = response.Body.Data; %获取服务器响应的内容
        result = content;
    else
        disp('请求失败')
    end
	end