import json
import time
from typing import Dict, Any

from httptools import send_post_request
import pandas as pd


def excel_to_api(excel_path: str, api_url: str, token: str, sheet_name: int | str = 0, preview_mode: bool = True):
    """
    读取Excel，逐行发送接口请求
    :param excel_path: Excel文件路径
    :param api_url: 接口地址
    :param token: 认证Token
    :param sheet_name: 工作表名/索引
    :param preview_mode: 预览模式开关 True=预览(不发请求) False=导入(真实发送)
    """
    # 读取Excel
    df = pd.read_excel(excel_path, sheet_name=sheet_name)

    # 给表格新增结果列 + 新增【请求体JSON】列
    df['请求状态'] = ''
    df['请求体JSON'] = ''
    df['错误信息'] = ''
    df['接口返回'] = ''

    total_rows = len(df)
    success_count = 0
    fail_count = 0
    print(f"✅ 读取完成，共 {total_rows} 行数据")
    print(f"🔘 当前模式：【{'预览模式（不发送请求）' if preview_mode else '导入模式（真实发送）'}】")
    print("开始处理数据...\n")

    # 逐行处理
    for index in range(total_rows):
        row = df.iloc[index]
        print(f"📝 正在处理第 {index + 1}/{total_rows} 行")

        try:
            # ==============================================
            # 【安全处理空值 + 无类型警告】
            # ==============================================
            # cid：安全转 int
            cid_val = row["cid"]
            cid: int = int(cid_val) if pd.notna(cid_val) else 0

            # 时间
            occ_time_val = row["occ_time"]
            occ_time: str = str(occ_time_val) if pd.notna(occ_time_val) else ""

            # 金额
            amount_val = row["amount"]
            amount: float = float(amount_val) if pd.notna(amount_val) else 0.0

            # 备注
            remark_val = row["remark"]
            remark: str = str(remark_val) if pd.notna(remark_val) else ""

            # 构建请求
            request_data: Dict[str, Any] = {
                "cid": cid,
                "occ_time": occ_time,
                "amount": amount,
                "remark": remark
            }

            # 格式化JSON，方便查看和保存
            json_str = json.dumps(request_data, ensure_ascii=False)
            print("【请求数据】：", json_str)

            # 🔥 把请求体JSON保存到Excel
            df.at[index, '请求体JSON'] = json_str

            # ==============================================
            # 【预览 / 导入 开关核心逻辑】
            # ==============================================
            if preview_mode:
                # 预览模式：不发请求，直接标记成功
                df.at[index, '请求状态'] = '预览成功'
                df.at[index, '接口返回'] = '预览模式，未调用接口'
                success_count += 1
                continue

            # 导入模式：真正发送请求
            time.sleep(0.1)
            headers = {
                'Content-Type': 'application/json',
                'X-Auth-Token': token
            }
            response, error = send_post_request(api_url, request_data, headers)

            if error:
                df.at[index, '请求状态'] = '失败'
                df.at[index, '错误信息'] = error
                fail_count += 1
                print(f"❌ 第 {index + 1} 行请求失败：{error}\n")
            else:
                df.at[index, '请求状态'] = '成功'
                df.at[index, '接口返回'] = json.dumps(response.json(), ensure_ascii=False, indent=2)
                success_count += 1
                print(f"✅ 第 {index + 1} 行请求成功\n")

        except Exception as e:
            err_msg = f"数据构建失败：{str(e)}"
            df.at[index, '请求状态'] = '失败'
            df.at[index, '错误信息'] = err_msg
            fail_count += 1
            print(f"⚠️ 第 {index + 1} 行：{err_msg}\n")

    # 保存结果
    output_path = "接口请求结果.xlsx"
    df.to_excel(output_path, index=False)

    # 汇总
    print("\n" + "=" * 50)
    print("📊  请求执行完成汇总")
    print(f"🔘 运行模式：{'预览模式' if preview_mode else '导入模式'}")
    print(f"📄 总条数：{total_rows}")
    print(f"✅ 成功/预览：{success_count} 条")
    print(f"❌ 失败：{fail_count} 条")
    print("=" * 50)
    print(f"\n🎉 全部处理完成！结果已保存到：{output_path}")


if __name__ == '__main__':
    # ====================== 配置项 ======================
    EXCEL_FILE = "2026.01.01-2026.03.31.xlsx"
    API_URL = "http://127.0.0.1:18200/v1/transactions"
    X_AUTH_TOKEN = ""  # 认证中心Token
    # 开关在这里！！！
    # True  = 预览模式（只打印数据，不发请求）
    # False = 导入模式（真实发送请求）
    PREVIEW_MODE = True
    # ====================================================

    excel_to_api(excel_path=EXCEL_FILE, api_url=API_URL, token=X_AUTH_TOKEN, preview_mode=PREVIEW_MODE)
