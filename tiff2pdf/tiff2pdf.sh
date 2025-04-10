#!/bin/bash
# sudo apt install imagemagick

# 设置输出PDF的DPI质量（可根据需要调整）
DPI=300

# 查找所有.tif和.tiff文件（包括单引号包裹的文件名）
find . -type f \( -iname "*.tif" -o -iname "*.tiff" -o -iname "'*.tif'" -o -iname "'*.tiff'" \) | while read -r file; do
    # 去除文件名中的单引号（如果有）
    clean_file=$(echo "$file" | sed "s/'//g")
    
    # 如果原始文件名包含单引号，则重命名文件（去除单引号）
    if [[ "$file" != "$clean_file" ]]; then
        mv "$file" "$clean_file"
    fi
    
    # 生成输出PDF文件名（将扩展名改为.pdf）
    pdf_file="${clean_file%.*}.pdf"
    
    # 使用ImageMagick转换
    echo "正在转换: $clean_file 为 $pdf_file"
    convert -density "$DPI" "$clean_file" "$pdf_file"
    
    # 检查转换是否成功
    if [ $? -eq 0 ]; then
        echo "转换成功: $pdf_file"
    else
        echo "转换失败: $clean_file"
    fi
done

echo "所有转换完成"