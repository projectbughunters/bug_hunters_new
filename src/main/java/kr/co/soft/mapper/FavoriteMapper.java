package kr.co.soft.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import kr.co.soft.beans.FavoriteBean;

public interface FavoriteMapper {
	
	@Insert("INSERT INTO favorites (member_idx, symbol, type) VALUES (#{member_idx}, #{symbol}, #{type})")
	  void insertFavorite(FavoriteBean favoriteBean);

	  @Select("SELECT member_idx, symbol, type FROM favorites WHERE member_idx = #{member_idx}")
	  List<FavoriteBean> selectFavoritesByMemberIdx(@Param("member_idx") int member_idx);

	  @Delete("DELETE FROM favorites WHERE symbol = #{symbol} and member_idx = #{member_idx}")
	  void deleteFavorite(@Param("symbol") String symbol, @Param("member_idx") int member_idx);


}
