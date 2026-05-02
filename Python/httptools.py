import requests
import json


def send_post_request(url, data_dict, headers=None, timeout=10):
    """
    发送POST请求并携带JSON数据

    参数:
        url (str): 请求的URL地址
        data_dict (dict): 要发送的字典数据，将被转换为JSON格式
        headers (dict, optional): 请求头信息，默认为包含JSON类型的头
        timeout (int, optional): 请求超时时间（秒），默认10秒

    返回:
        tuple: (响应对象, 错误信息)
               成功时错误信息为None，失败时响应对象为None
    """
    # 设置默认请求头，指定JSON格式
    default_headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    }

    # 如果用户提供了 headers，则合并（用户提供的会覆盖默认的）
    if headers:
        default_headers.update(headers)

    try:
        # 将字典转换为JSON字符串
        json_data = json.dumps(data_dict, ensure_ascii=False)
        # 发送POST请求
        response = requests.post(
            url=url,
            data=json_data,
            headers=default_headers,
            timeout=timeout
        )

        # 检查响应状态码，200-299视为成功
        response.raise_for_status()

        return response, None

    except requests.exceptions.HTTPError as e:
        return None, f"HTTP错误: {str(e)}"
    except requests.exceptions.ConnectionError:
        return None, "连接错误: 无法连接到服务器"
    except requests.exceptions.Timeout:
        return None, f"超时错误: 请求超过{timeout}秒未响应"
    except json.JSONDecodeError:
        return None, "JSON编码错误: 数据转换为JSON格式失败"
    except Exception as e:
        return None, f"未知错误: {str(e)}"
