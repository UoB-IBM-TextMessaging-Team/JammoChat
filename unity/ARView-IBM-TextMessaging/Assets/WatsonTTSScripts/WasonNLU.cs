
/**
* (C) Copyright IBM Corp. 2019, 2020.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
*/

using IBM.Watson.NaturalLanguageUnderstanding.V1;
using IBM.Watson.NaturalLanguageUnderstanding.V1.Model;
using IBM.Cloud.SDK.Utilities;
using IBM.Cloud.SDK.Authentication;
using IBM.Cloud.SDK.Authentication.Iam;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using IBM.Cloud.SDK;
using System.Text.RegularExpressions;


public class WasonNLU 
{
/*    #region PLEASE SET THESE VARIABLES IN THE INSPECTOR
    [Space(10)]
    [Tooltip("The IAM apikey.")]
    [SerializeField]
    private string iamApikey;
    [Tooltip("The service URL (optional). This defaults to \"https://api.us-south.natural-language-understanding.watson.cloud.ibm.com\"")]
    [SerializeField]
    private string serviceUrl;
    [Tooltip("The version date with which you would like to use the service in the form YYYY-MM-DD.")]
    [SerializeField]
    private string versionDate;
    #endregion*/


    private WatsonSettings settings;
    private const string iamApikey = "U_Wd0zXTjUsWXvtZNbvr66ylrIBdUxlDF8qjQKkLncdR";
    private const string serviceUrl = "https://api.eu-gb.natural-language-understanding.watson.cloud.ibm.com/instances/b8af7dc3-c234-4307-bd91-596656623719" ;
    private const string versionDate = "2022-04-07";
    private string emotionResult = null;
    private string nluText;
    private string nluLanguage = "en";
    public AnalysisResults analyzeResponse;
    public WasonNLU(string text)
    {
        nluText = text;
        analyzeNLU();
    }
    public WasonNLU()
    {
    }
    public string sendTextToNLU(string text)
    {
        nluText = text;
        analyzeNLU();
        return emotionResult;
    }

    public void clean()
    {
        emotionResult = null;
        analyzeResponse = null;
    }
    public AnalysisResults getAnalysisResults()
    {
        return analyzeResponse;
    }

    public void setNLULanguage(string inputLanguage)
    {
        switch(inputLanguage){
            case "fr":
                nluLanguage = "fr";
                break;
            case "en":
                nluLanguage = "en";
                break;
            default:
                nluLanguage = "en";
                break;
        }        
    }

    private NaturalLanguageUnderstandingService service;
    //private string nluText = "IBM is an American multinational technology company headquartered in Armonk, New York, United States with operations in over 170 countries.";
    //private string nluText = "I'm feeling pretty good right now";
    
    
    private void analyzeNLU()
    {
        Debug.Log("StartNLU");
        LogSystem.InstallDefaultReactors();
        Runnable.Run(CreateService());
    }

    private IEnumerator CreateService()
    {
        if (string.IsNullOrEmpty(iamApikey))
        {
            throw new IBMException("Please add IAM ApiKey to the Iam Apikey field in the inspector.");
        }

        IamAuthenticator authenticator = new IamAuthenticator(apikey: iamApikey);

        while (!authenticator.CanAuthenticate())
        {
            yield return null;
        }

        service = new NaturalLanguageUnderstandingService(versionDate, authenticator);
        if (!string.IsNullOrEmpty(serviceUrl))
        {
            Debug.Log(serviceUrl);
            service.SetServiceUrl(serviceUrl);
        }

        Runnable.Run(ExampleAnalyze());
/*        if(emotionResult == null)
        {
            Runnable.Run(ExampleTargetAnalyze());
        }*/
        //Runnable.Run(ExampleListModels());
        //Runnable.Run(ExampleDeleteModel());
    }

    private IEnumerator ExampleAnalyze()
    {
        Features features = new Features()
        {
            
            Emotion = new EmotionOptions()
            {
                //Targets = new List<string>
            }
        };
        analyzeResponse = null;

        service.Analyze(
            callback: (DetailedResponse<AnalysisResults> response, IBMError error) =>
            {
                Log.Debug("NaturalLanguageUnderstandingServiceV1", "Analyze result: {0}", response.Response);
                emotionResult = response.Response;
                analyzeResponse = response.Result;
            },
            features: features,
            text: nluText,
            language: nluLanguage
        //url: serviceUrl
        );
        //Debug.Log("NLU"+emotionResult);
        while (analyzeResponse == null)
            yield return null;
    }

/*    private IEnumerator ExampleTargetAnalyze()
    {
        //List<string> list = new List<string>(nluText.Split("\\s+"));
        string[] mm = Regex.Split(nluText, "\\s+", RegexOptions.IgnoreCase);
        List<System.String> listS = new List<System.String>(mm);
        Features features = new Features()
        {
            Emotion = new EmotionOptions()
            {
                Targets = listS
                //Document = false
            }
        };
        analyzeResponse = null;

        service.Analyze(
            callback: (DetailedResponse<AnalysisResults> response, IBMError error) =>
            {
                Log.Debug("NaturalLanguageUnderstandingServiceV1", "Analyze result: {0}", response.Response);
                emotionResult = response.Response;
                analyzeResponse = response.Result;
            },
            features: features,
            text: nluText
        //url: serviceUrl
        );
        Debug.Log("NLU" + emotionResult);
        while (analyzeResponse == null)
            yield return null;
    }*/


    public string getResult()
    {
        return emotionResult;
    }


    /* private IEnumerator ExampleListModels()
     {
         ListModelsResults listModelsResponse = null;
         Debug.Log("ExampleListModels");
         service.ListModels(
             callback: (DetailedResponse<ListModelsResults> response, IBMError error) =>
             {
                 Log.Debug("NaturalLanguageUnderstandingServiceV1", "ListModels result: {0}", response.Response);
                 listModelsResponse = response.Result;
             }

         );

         while (listModelsResponse == null)
             yield return null;
     }
 */
    /* private IEnumerator ExampleDeleteModel()
     {
         DeleteModelResults deleteModelResponse = null;
         Debug.Log("ExampleDeleteModel");
         service.DeleteModel(
             callback: (DetailedResponse<DeleteModelResults> response, IBMError error) =>
             {
                 Log.Debug("NaturalLanguageUnderstandingServiceV1", "DeleteModel result: {0}", response.Response);
                 deleteModelResponse = response.Result;
             },

             modelId: "<analyze>" // Enter model Id here
         );

         while (deleteModelResponse == null)
             yield return null;
     }*/

}