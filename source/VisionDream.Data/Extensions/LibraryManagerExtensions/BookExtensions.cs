﻿/* ****************************************************************************
 * Copyright 2020 VisionDream ICT Solutions
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy 
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 * ***************************************************************************/

using VisionDream.Data.Models.LibraryManagerModels;

namespace VisionDream.Data.Extensions.LibraryManagerExtensions
{
    /// <summary>
    /// The static <see cref="BookExtensions"/> class helps to map <see cref="Map"/> 
    /// to each other the same two <see cref="Book"/> object entities, for further 
    /// processing.
    /// </summary>
    public static class BookExtensions
    {
        public static void Map(this Book destBook, Book srcBook)
        {
            destBook.Id = srcBook.Id;
            destBook.Name = srcBook.Name;
            destBook.Author = srcBook.Author;
            destBook.CreatedDate = srcBook.CreatedDate;
        }
    }
}
