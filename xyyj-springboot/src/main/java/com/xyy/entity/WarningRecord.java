package com.xyy.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 预警记录表
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@TableName("warning_record")
public class WarningRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 预警编号
     */
    @TableField("warning_id")
    private String warningId;

    /**
     * 学号
     */
    @TableField("student_id")
    private String studentId;

    /**
     * 学生姓名
     */
    @TableField("student_name")
    private String studentName;

    /**
     * 预警类型(GRADE:成绩,ATTENDANCE:考勤,BEHAVIOR:行为)
     */
    @TableField("warning_type")
    private String warningType;

    /**
     * 预警等级(1:一级,2:二级,3:三级)
     */
    @TableField("warning_level")
    private Integer warningLevel;

    /**
     * 预警描述
     */
    @TableField("description")
    private String description;

    /**
     * 状态(PENDING:待处理,PROCESSING:处理中,PROCESSED:已处理)
     */
    @TableField("status")
    private String status;

    /**
     * 创建人ID
     */
    @TableField("create_user_id")
    private Long createUserId;

    /**
     * 创建时间
     */
    @TableField("create_time")
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @TableField("update_time")
    private LocalDateTime updateTime;

    /**
     * 学院
     */
    @TableField("college")
    private String college;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getWarningId() {
        return warningId;
    }

    public void setWarningId(String warningId) {
        this.warningId = warningId;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getWarningType() {
        return warningType;
    }

    public void setWarningType(String warningType) {
        this.warningType = warningType;
    }

    public Integer getWarningLevel() {
        return warningLevel;
    }

    public void setWarningLevel(Integer warningLevel) {
        this.warningLevel = warningLevel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(Long createUserId) {
        this.createUserId = createUserId;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    @Override
    public String toString() {
        return "WarningRecord{" +
            "id = " + id +
            ", warningId = " + warningId +
            ", studentId = " + studentId +
            ", studentName = " + studentName +
            ", warningType = " + warningType +
            ", warningLevel = " + warningLevel +
            ", description = " + description +
            ", status = " + status +
            ", createUserId = " + createUserId +
            ", createTime = " + createTime +
            ", updateTime = " + updateTime +
            ", college = " + college +
        "}";
    }
}
