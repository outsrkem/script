from kubernetes import client, config
import json, os, sys

# 获取当前文件路径
BASE_DIR = os.path.abspath(os.curdir)
# 指定kubeconfi.yaml 文件
KUBECONF = os.path.join(BASE_DIR, 'kubeconfig.yaml')
config.kube_config.load_kube_config(config_file=KUBECONF)

clusername = "default"

# 获取API的CoreV1Api版本对象
v1 = client.CoreV1Api()
print(v1)
# 列出所有的pod
ret = v1.list_pod_for_all_namespaces(watch=False)
print(ret)
for i in ret.items:
    if i.metadata.namespace == clusername:
        print("=======================================================================")
        print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
        ret1 = v1.read_namespaced_pod(namespace=clusername, name=i.metadata.name)
        print(ret1.status.host_ip)
        print(ret1.spec.containers[0].ports[0].container_port)
        ret2 = ret1.status.container_statuses[0].state.waiting
        if ret2 == None:
            print("running")
        else:
            print(ret2.reason)
        logs = v1.read_namespaced_pod_log(namespace=clusername, name=i.metadata.name)
        print(logs)
