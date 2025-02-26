package kr.co.soft.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface ProfileMapper {


	@Update("UPDATE profile SET personal_tendency_code=#{personal_tendency_code} WHERE member_idx=#{member_idx}")
	void updateTendencyCode(@Param("personal_tendency_code")String personal_tendency_code, @Param("member_idx")int member_idx);
	
	
	@Select("SELECT personal_tendency_code FROM profile WHERE member_idx=#{member_idx}")
	String getTendencyCode(int member_idx);
}
