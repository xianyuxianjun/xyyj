package com.xyy.controller;

import com.xyy.config.FileProperties;
import com.xyy.service.IAttachmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import com.xyy.common.Result;
import com.xyy.entity.Attachment;
import java.time.LocalDateTime;

/**
 * <p>
 * 附件表 前端控制器
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@CrossOrigin
@RestController
@RequestMapping("/attachment")
public class AttachmentController {
    @Autowired
    private IAttachmentService attachmentService;

    @Autowired
    private FileProperties fileProperties;

    // 使用配置的上传路径
    private String getUploadPath() {
        return fileProperties.getUploadDir() + File.separator;
    }

    @PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) {
        try {
            // 检查上传目录是否存在，不存在则创建
            File uploadDir = new File(getUploadPath());
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成新的文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;

            // 保存文件
            File destFile = new File(getUploadPath() + newFilename);
            file.transferTo(destFile);

            // 保存文件信息到数据库
            Attachment attachment = new Attachment();
            attachment.setOriginalName(originalFilename);
            attachment.setFileName(newFilename);
            attachment.setFileSize(file.getSize());
            attachment.setFileType(extension);
            attachment.setFilePath(getUploadPath() + newFilename);
            attachmentService.save(attachment);

            return Result.success(attachment);
        } catch (Exception e) {
            return Result.error("文件上传失败：" + e.getMessage());
        }
    }

    @PostMapping("/batch-upload")
    public Result batchUpload(@RequestParam("files") MultipartFile[] files) {
        List<Attachment> attachments = new ArrayList<>();
        try {
            for (MultipartFile file : files) {
                // 检查上传目录是否存在，不存在则创建
                File uploadDir = new File(getUploadPath());
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 生成新的文件名
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFilename = UUID.randomUUID().toString() + extension;

                // 保存文件
                File destFile = new File(getUploadPath() + newFilename);
                file.transferTo(destFile);

                // 保存文件信息到数据库
                Attachment attachment = new Attachment();
                attachment.setOriginalName(originalFilename);
                attachment.setFileName(newFilename);
                attachment.setFileSize(file.getSize());
                attachment.setFileType(extension);
                attachment.setFilePath(getUploadPath() + newFilename);
                attachmentService.save(attachment);
                
                attachments.add(attachment);
            }
            return Result.success(attachments);
        } catch (Exception e) {
            return Result.error("批量文件上传失败：" + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result getAttachment(@PathVariable Integer id) {
        return Result.success(attachmentService.getById(id));
    }

    @DeleteMapping("/{id}")
    public Result deleteAttachment(@PathVariable Integer id) {
        Attachment attachment = attachmentService.getById(id);
        if (attachment != null) {
            // 删除物理文件
            File file = new File(attachment.getFilePath());
            if (file.exists()) {
                file.delete();
            }
            // 删除数据库记录
            attachmentService.removeById(id);
        }
        return Result.success();
    }
}
