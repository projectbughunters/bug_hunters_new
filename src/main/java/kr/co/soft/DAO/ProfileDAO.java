package kr.co.soft.DAO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.mapper.ProfileMapper;

@Repository
public class ProfileDAO {

	
	@Autowired
	private ProfileMapper profileMapper;
	
	public void updateTendencyCode(String tendencyCode, int member_idx) {
		profileMapper.updateTendencyCode(tendencyCode, member_idx);
	}
	
	public String getTendencyCode(int member_idx) {
		String tendencyCode=profileMapper.getTendencyCode(member_idx);
		return tendencyCode;
	}
}
 