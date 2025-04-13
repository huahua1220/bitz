#!/bin/bash
#保存之后在根目录运行一下chmod +x claim.sh
#然后./claim.sh运行

# 支付gas的keypair路径
FEE_PAYER="/home/ubuntu/.config/solana/id.json"
# 归集bitz的主地址
TO_ADDRESS="address"
# RPC链接
RPC_URL="https://eclipse.helius-rpc.com/"
# 处理多少个个钱包，自己改，是从id1开始计算
COUNT=10 

echo "start..."

claim_funds() {
    local keypair=$1
    local keypair_name=$(basename "$keypair" .json)
    echo "run.. $keypair_name..."
    sleep 1
    echo "Y" | bitz claim --keypair "$keypair" --fee-payer "$FEE_PAYER" --to "$TO_ADDRESS" --rpc "$RPC_URL"
}

KEYPAIRS=()
for ((i=1; i<=$COUNT; i++)); do
    #把这个路径/home/ubuntu/.config/solana 换成你的keypair路径
    KEYPAIRS+=("/home/ubuntu/.config/solana/id$i.json")
    #如果不是id1这种命名，比如直接命名的1.json，那就把后面的id删掉(/home/ubuntu/.config/solana/$i.json)
done

for keypair in "${KEYPAIRS[@]}"; do
    if [ -f "$keypair" ]; then
        claim_funds "$keypair" &
    else
        echo " $keypair 不存在，已跳过"
    fi
done

wait

echo "End"
