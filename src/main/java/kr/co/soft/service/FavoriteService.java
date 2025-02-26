package kr.co.soft.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.soft.DAO.FavoriteDAO;
import kr.co.soft.beans.FavoriteBean;

@Service
public class FavoriteService {

  @Autowired
  private FavoriteDAO favoriteDAO;

  public void insertFavorite(FavoriteBean favoriteBean) {
	    favoriteDAO.insertFavorite(favoriteBean);
	  }

	  public List<FavoriteBean> selectFavoritesByMemberIdx(int member_idx) {
	    return favoriteDAO.selectFavoritesByMemberIdx(member_idx);
	  }

	  public void deleteFavorite(String symbol, int member_idx) {
	    // 즐겨찾기 삭제 로직
	    favoriteDAO.deleteFavorite(symbol, member_idx);
	  }

}
