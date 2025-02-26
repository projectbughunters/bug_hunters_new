package kr.co.soft.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.beans.FavoriteBean;
import kr.co.soft.mapper.FavoriteMapper;

@Repository
public class FavoriteDAO {

  @Autowired
  private FavoriteMapper favoriteMapper;

  public void insertFavorite(FavoriteBean favoriteBean) {
	    favoriteMapper.insertFavorite(favoriteBean);
	  }

	  public List<FavoriteBean> selectFavoritesByMemberIdx(int member_idx) {
	    return favoriteMapper.selectFavoritesByMemberIdx(member_idx);
	  }

	  public void deleteFavorite(String symbol, int member_idx) {
	    favoriteMapper.deleteFavorite(symbol, member_idx);
	  }


}
