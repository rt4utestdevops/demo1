package t4u.beans;

import java.io.Serializable;

/**
 * 
 * This bean is used to store the language specific words
 *
 */
public class LanguageWordsBean implements Serializable{

	private String arabicWord;
	private String englishWord;
	
	public String getArabicWord(){
		return arabicWord;
	}
	public void setArabicWord(String arabicWord){
		this.arabicWord=arabicWord;
	}
	
	public String getEnglishWord(){
		return englishWord;
	}
	public void setEnglishWord(String englishWord){
		this.englishWord=englishWord;
	}
}
