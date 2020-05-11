import os
import requests
import subprocess

from tqdm import tqdm

from run import check_for_updates

required_version = check_for_updates()

if required_version:
    url = f"https://github.com/ebmdatalab/opensafely-research-template/releases/download/v{required_version}/windows_run_wrapper.exe"
    response = requests.get(url, stream=True)
    response.raise_for_status()
    t = tqdm(desc="Downloading new version...", unit="bytes", unit_scale=True)
    with open("windows_run_wrapper.exe.tmp", "wb") as f:
        chunk_size = 2 ** 18  # 256k
        for data in response.iter_content(chunk_size=chunk_size):
            f.write(data)
            t.update(len(data))
    os.replace("windows_run_wrapper.exe.tmp", "windows_run_wrapper.exe")
subprocess.run(["windows_run_wrapper.exe"])
