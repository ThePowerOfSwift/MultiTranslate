//
//  SupportedLanguages.swift
//  MultiTranslate
//
//  Created by Keishin CHOU on 2020/02/05.
//  Copyright © 2020 Keishin CHOU. All rights reserved.
//

import Foundation

struct SupportedLanguages {
    static let gcpLanguageList = [
        "Afrikaans",
        "Albanian",
        "Amharic",
        "Arabic",
        "Armenian",
        "Azerbaijani",
        "Basque",
        "Belarusian",
        "Bengali",
        "Bosnian",
        "Bulgarian",
        "Catalan",
        "Cebuano",
        "Chinese (Mandarin)",
        "Chinese (HK)",
        "Corsican",
        "Croatian",
        "Czech",
        "Danish",
        "Dutch",
        "English",
        "Esperanto",
        "Estonian",
        "Finnish",
        "French",
        "Frisian",
        "Galician",
        "Georgian",
        "German",
        "Greek",
        "Gujarati",
        "Haitian Creole",
        "Hausa",
        "Hawaiian",
        "Hebrew",
        "Hindi",
        "Hmong",
        "Hungarian",
        "Icelandic",
        "Igbo",
        "Indonesian",
        "Irish",
        "Italian",
        "Japanese",
        "Javanese",
        "Kannada",
        "Kazakh",
        "Khmer",
        "Korean",
        "Kurdish",
        "Kyrgyz",
        "Lao",
        "Latin",
        "Latvian",
        "Lithuanian",
        "Luxembourgish",
        "Macedonian",
        "Malagasy",
        "Malay",
        "Malayalam",
        "Maltese",
        "Maori",
        "Marathi",
        "Mongolian",
        "Myanmar (Burmese)",
        "Nepali",
        "Norwegian",
        "Nyanja (Chichewa)",
        "Pashto",
        "Persian",
        "Polish",
        "Portuguese",
        "Punjabi",
        "Romanian",
        "Russian",
        "Samoan",
        "Scots Gaelic",
        "Serbian",
        "Sesotho",
        "Shona",
        "Sindhi",
        "Sinhala (Sinhalese)",
        "Slovak",
        "Slovenian",
        "Somali",
        "Spanish",
        "Sundanese",
        "Swahili",
        "Swedish",
        "Tagalog (Filipino)",
        "Tajik",
        "Tamil",
        "Telugu",
        "Thai",
        "Turkish",
        "Ukrainian",
        "Urdu",
        "Uzbek",
        "Vietnamese",
        "Welsh",
        "Xhosa",
        "Yiddish",
        "Yoruba",
        "Zulu"
    ]
    
    static let gcpLanguageCode = [
        "af","sq","am","ar","hy","az","eu","be","bn","bs","bg","ca","ceb","zh-CN","zh-TW","co","hr","cs","da","nl","en","eo","et","fi","fr","fy","gl","ka","de",
        "el","gu","ht","ha","haw","he","hi","hmn","hu","is","ig","id","ga","it","ja","jv","kn","kk","km","ko","ku","ky","lo","la","lv","lt","lb","mk","mg","ms",
        "ml","mt","mi","mr","mn","my","ne","no","ny","ps","fa","pl","pt","pa","ro","ru","sm","gd","sr","st","sn","sd","si","sk","sl","so","es","su","sw","sv",
        "tl","tg","ta","te","th","tr","uk","ur","uz","vi","cy","xh","yi","yo","zu"
    ]
    
    static let speechRecognizerSupportedLocaleIdentifier = [
        // Use for speech recognizing
        "ar-SA", "ca-ES", "cs-CZ", "da-DK", "de-AT", "de-CH", "de-DE", "el-GR", "en-AU", "en-CA", "en-GB", "en-IE", "en-IN", "en-NZ", "en-PH",
        "en-SA", "en-SG", "en-US", "en-ZA", "es-419", "es-CL", "es-CO", "es-ES", "es-MX", "es-US", "fi-FI", "fr-BE", "fr-CA", "fr-CH", "fr-FR", "he-IL", "hi-IN",
        "hr-HR", "hu-HU", "id-ID", "it-CH", "it-IT", "ja-JP", "ko-KR", "ms-MY", "nb-NO", "nl-BE", "nl-NL", "pl-PL", "pt-BR", "pt-PT",
        "ro-RO", "ru-RU", "sk-SK", "sv-SE", "th-TH", "tr-TR", "uk-UA", "vi-VN", "zh-CN", "zh-HK"
//        "ar-SA", "ca-ES", "cs-CZ", "da-DK", "de-AT", "de-CH", "de-DE", "el-GR", "en-AE", "en-AU", "en-CA", "en-GB", "en-ID", "en-IE", "en-IN", "en-NZ", "en-PH",
//        "en-SA", "en-SG", "en-US", "en-ZA", "es-419", "es-CL", "es-CO", "es-ES", "es-MX", "es-US", "fi-FI", "fr-BE", "fr-CA", "fr-CH", "fr-FR", "he-IL", "hi-IN",
//        "hi-IN-translit", "hi-Latn", "hr-HR", "hu-HU", "id-ID", "it-CH", "it-IT", "ja-JP", "ko-KR", "ms-MY", "nb-NO", "nl-BE", "nl-NL", "pl-PL", "pt-BR", "pt-PT",
//        "ro-RO", "ru-RU", "sk-SK", "sv-SE", "th-TH", "tr-TR", "uk-UA", "vi-VN", "wuu-CN", "yue-CN", "zh-CN", "zh-HK", "zh-TW"
    ]
    
    static let speechRecognizerSupportedLocale = [
        // Use for display in LanguagePickerViewController
        "Arabic (Saudi Arabia)", "Catalan (Spain)", "Czech (Czech)", "Danish", "German (Austria)", "German (Switzerland)", "German (Germany)", "Greek", "English (Australia)",
        "English (Canada)", "English (United Kingdom)", "English (Ireland)", "English (India)", "English (New Zealand)", "English (Philippines)",
        "English (Saudi Arabia)", "English (Singapore)", "English (United States)", "English (South Africa)", "Spanish (Latin America & Caribbean)", "Spanish (Chile)", "Spanish (Colombia)",
        "Spanish (Spain)", "Spanish (Mexico)", "Spanish (United States)", "Finnish (Finland)", "French (Belgium)", "French (Canada)", "French (Switzerland)",
        "French (France)", "Hebrew (Israel)", "Hindi (India)", "Croatian (Croatia)", "Hungarian (Hungary)", "Indonesian (Indonesia)", "Italian (Switzerland)",
        "Italian (Italy)", "Japanese (Japan)", "Korean (Korea)", "Malay (Malaysia)", "Norwegian (Norway)", "Dutch (Belgium)", "Dutch (Netherlands)", "Polish (Poland)",
        "Portuguese (Brazil)", "Portuguese (Portugal)", "Romanian (Romania)", "Russian (Russia)", "Slovak (Slovakia)", "Swedish (Sweden)", "Thai (Thailand)",
        "Turkish (Turkey)", "Ukrainian (Ukraine)", "Vietnamese (Vietnam)", "Chinese (China)", "Chinese (Hongkong)"
    ]
    
    static let speechRecognizerSupportedLanguage = [
        // Use for display in VoiceTranslationViewController
        "Arabic", "Catalan", "Czech", "Danish", "German", "German", "German", "Greek", "English",
        "English", "English", "English", "English", "English", "English",
        "English", "English", "English", "English", "Spanish", "Spanish", "Spanish",
        "Spanish", "Spanish", "Spanish", "Finnish", "French", "French", "French",
        "French", "Hebrew", "Hindi", "Croatian", "Hungarian", "Indonesian", "Italian",
        "Italian", "Japanese", "Korean", "Malay", "Norwegian", "Dutch", "Dutch", "Polish",
        "Portuguese", "Portuguese", "Romanian", "Russian", "Slovak", "Swedish", "Thai",
        "Turkish", "Ukrainian", "Vietnamese", "Chinese (Mandarin)", "Chinese (HK)"
    ]
    
    static let speechRecognizerSupportedLanguageCode = [
        //Use for translating
        "ar", "ca", "cs", "da", "de", "de", "de", "el", "en", "en", "en", "en", "en", "en", "en",
        "en", "en", "en", "en", "es", "es", "es", "es", "es", "es", "fi", "fr", "fr", "fr", "fr", "he", "hi",
        "hr", "hu", "id", "it", "it", "ja", "ko", "ms", "nb", "nl", "nl", "pl", "pt", "pt",
        "ro", "ru", "sk", "sv", "th", "tr", "uk", "vi", "zh", "zh"
    ]
}
