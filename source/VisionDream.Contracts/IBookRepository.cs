/* ****************************************************************************
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

using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using VisionDream.Data.Models.LibraryManagerModels;
using VisionDream.Data.ExtendedModels.LibraryManagerExtendedModels;

namespace VisionDream.Contracts
{
    public interface IBookRepository : IRepositoryBase<Book>
    {
        Task<IEnumerable<Book>> GetAllAsyncData();
        Task<Book> GetByIdAsyncData(int bookId);
        Task<BookExtended> GetByIdExtendedAsyncData(int bookId);
        Task PostCreateAsyncData(Book book);
        Task PutUpdateAsyncData(Book dbBook, Book book);
        Task DeleteByIdAsyncData(Book book);
        bool GetByIdAsyncData(Func<object, bool> b);
    }
}
